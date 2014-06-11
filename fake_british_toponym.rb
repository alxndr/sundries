class FakeBritishToponym < String

  ANTEFIXES = %w( east great little new north old port saint south west )
  PREFIXES  = %w( aber avon ash bex birm blen brad bre burn car chef cul dal don dun ex gains glou hex hol in inver ips kil kings knock lan leigh lin lock lon long lough lyme man mannan mid middle mills moss new nor not oak ock old pad pen puds shrews stan stin sud sur swin tarn thorn tilly tre up wake wall well wey which wil win wor worth yar )
  INFIXES   = %w( beck caster ces cester cot er folk ford glen ham hamp her ill ing kirk more ness nock ter tun ton wich )
  SUFFIXES  = %w( bie borough bost born burgh bury bridge by carden cay chester church combe dale deen den don dun ey field firth fork forth frith garth gate head holm hop hurst inge keld lan land law leigh ley low minster moth mouth orth over pool rith rock sbury set shaw shep ship shire stead ster stone ter thorp tham thwait tyne well wich wold wick )
  POSTFIXES = %w( bight castle crossing downs gate glen grove hall hamlet -in- marsh of -on- -on-the- river 's sands town -under- -upon- village water willow )

  def initialize(**args)
    args[:modifier] = true unless args.has_key? :modifier
    args[:min_syllables] = 2 unless args.has_key? :min_syllables

    @pieces = [random_prefix.capitalize]

    rand(args[:min_syllables]).times do
      @pieces.push pick_infix
    end

    if @pieces.length == 1 || rand(10) % 3 == 0
      pick = random_suffix
      double_last_letter_if_needed(pick)
      @pieces.push pick
    end

    if args[:modifier] && rand(10) % 5 == 0
      if rand(2) == 0
        add_antefix
      else
        add_postfix
      end
    end

    @name = @pieces.join.to_s

    super @name # do some String-y things
  end

  def to_str
    @name.to_s
  end

  private

  def add_antefix
    @pieces.unshift random_antefix.capitalize+' '
  end

  def add_postfix
    # this sure sucks
    pick = random_postfix
    if pick.match(/^-/)
      @pieces.push pick
      @pieces.push self.class.new(modifier: false)
    elsif pick == 'of'
      @pieces.push ' '+pick+' '
      @pieces.push self.class.new(modifier: false)
    elsif pick == "'s"
      @pieces.push pick+' '
      @pieces.push self.class.new(modifier: false)
    else
      @pieces.push ' '+pick.capitalize
    end
  end

  def pick_infix
    begin
      pick = random_infix
    end while pick == @pieces.last # try not to double up syllables
    double_last_letter_if_needed(pick)
    pick
  end

  %w(ante pre in suf post).each do |which|
    define_method("random_#{which}fix") do
      corpus = eval "#{which}fixes".upcase
      corpus.sample
    end
  end

  def double_last_letter_if_needed(pick)
    # obviously this should be just two things
    return unless pick.match(/^[aeiou]/)
    return if @pieces.last.match(/^[aeiou]/)
    return if @pieces.last[-1] == @pieces.last[-2] # don't triple
    last_piece = @pieces.pop
    @pieces.push last_piece + last_piece[-1]
  end

end
