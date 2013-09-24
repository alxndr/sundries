#!/usr/bin/ruby

require 'uri/http'
require 'open-uri'
require 'optparse'
require 'ostruct'

class OptionsDescription
  def usage
    raise 'template method'
  end
end

def options
  return @_options if @_options

  @_options = OpenStruct.new
  OptionParser.new do |opts|
    opts.on(
      '-u',
      '--url URL',
      'URL to grab'
    ) do |u|
      @_options.url = u
    end
    opts.on(
      '-r',
      '--regex REGEX',
      'regex to look for'
    ) do |r|
      @_options.regex = r
    end
    opts.on(
      '-d',
      '--dir [DIR]',
      'DIR to store files in',
      'defaults to /tmp}'
    ) do |d|
      @_options.dir = d
    end
    opts.on(
      '-v',
      '--verbose',
      'enable verbose mode'
    ) do
      @_options.verbose = true
    end
    opts.on_tail(
      '-h',
      '--help',
      'Show this message'
    ) do
      puts opts
      exit
    end
  end.parse!(ARGV)
  if @_options.regex.nil? || @_options.url.nil?
    puts 'Missing regex!' if @_options.regex.nil? || @_options.regex.empty?
    puts 'Missing url!' if @_options.url.nil? || @_options.url.empty?
    puts 'Exiting...'
    exit
  end
  @_options.dir ||= '/tmp'
  @_options
end

def main
  puts "Results stored following the pattern #{File.join(options.dir, filename_pattern)}" if options.verbose
  feed = open(options.url).read
  regex = /^(.*#{options.regex}.*)$/ # ^$ and not \A\Z
  match = feed.match(regex)
  if match
    File.open(File.join(options.dir, filename_pattern % Time.now.to_i), 'w') do |saved_file|
      puts "Saving XML plus match to #{saved_file.path}" if options.verbose
      String.class_eval do
        define_method :to_html_comment do
          "<!-- #{gsub('--', '- - ')} -->"
        end
      end
      saved_file.puts feed
      saved_file.puts Time.now.to_s.to_html_comment
      puts match.captures.first.inspect
      saved_file.puts match.captures.first.to_html_comment
    end 
  end 
end

def filename_pattern
  return @_filename_pattern if @_filename_pattern
  hostname_method = RUBY_VERSION >= '1.9.3' ? :hostname : :host
  @_filename_pattern = simplify(URI.parse(options.url).send(hostname_method)) + '-' + simplify(options.regex.to_s) + '-%d.xml'
end

def simplify(str)
  str.gsub(/[^a-z]/,'')
end

main if $0

