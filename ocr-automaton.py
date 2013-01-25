#!/usr/bin/python
# OCR Automaton
# given a directory of images, runs the images through OCR and puts text into files in directory/ocr/

import sys, glob, commands, os
from time import time
from glob import glob

if len(sys.argv) == 1 or not os.path.isdir(sys.argv[1]) or 'help' in sys.argv:
	print '''ocr-automaton.py help:
	help: displays this
ocr-automaton.py directory/ [noappend]:
	directory: looks for images in directory, converts & ocrs into directory/ocr/
	[noappend]: do not cat all OCR results together into directory/ocr/all.txt

images can be jpg, tif, png, gif, or any pnm
requirements: tesseract, anytopnm, pnmtotiff
'''
else:
	starttime = time()
	
	dirname = sys.argv[1]
	if dirname[-1] != '/':
		dirname += '/'
	os.chdir(dirname)
	
	images = []
	for ext in ['jpg','tif','png','gif','pbm','pgm','ppm','pnm']:
		images.extend( glob('*.%s' % (ext)) )
		images.extend( glob('*.%s' % (ext.swapcase())) )
	if images == []:
		raise Exception('no images found!')
	
	try:
		os.mkdir('ocr')
	except OSError:
		print "looks like ocr/ already exists..."
	
	images.sort()
	imagecount = 0 # there's gotta be a more elegant way to do this
	if 'append' in sys.argv or 'noappend' not in sys.argv:
		allocr = ''
	for image in images:
		imagecount += 1
		print 'image %s of %s:' % (imagecount, len(images))
		(filename, ext) = os.path.splitext(image)
		
		#if ext.lower() not in ['.pbm','.pgm','.ppm','.pnm']:
		#	print '\tconverting to pnm'
		#	status = commands.getstatusoutput('%s %s > %s.pnm' % ('anytopnm',image,filename))
		#	if status[0] != 0: print status
		#if ext.lower() != '.tif': # we've already got a pnm
		#	print '\tconverting to tif'
		#	status = commands.getstatusoutput('%s %s.p*m > %s.tif' % ('pnmtotiff',filename,filename))
		#	if status[0] != 0: print status
		
		print '\trunning tesseract'
		status = commands.getstatusoutput('tesseract %s.tif ocr/%s' % (filename,filename)) # puts .txt on automatically
		if status[0] != 0: print status
		
		print '\tdeleting temp images'
		#if ext.lower() not in ['.pbm','.pgm','.ppm','.pnm']:
		#	status = commands.getstatusoutput('rm %s.pnm' % (filename))
		#if status[0] != 0: print status
		#if ext.lower() != '.tif':
		#	status = commands.getstatusoutput('rm %s.tif' % (filename))
		#	if status[0] != 0: print status
		
		if 'append' in sys.argv or 'noappend' not in sys.argv:
			lastocr = open('ocr/%s.txt' % (filename),'r')
			allocr += lastocr.read()
			lastocr.close()
	#/for
	
	if 'append' in sys.argv or 'noappend' not in sys.argv:
		if os.path.exists('ocr/all.txt'):
			print 'can\'t append, ocr/all.txt already exists!'
		else:
			print 'writing ocr/all.txt'
			allout = open('ocr/all.txt','w')
			allout.write(allocr)
			allout.close()
	
	runtime = time()-starttime
	print 'Done (took %d seconds, %.1f sec per image)' % (runtime, runtime/len(images))
