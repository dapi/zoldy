# Save actual and fetch reduced score. This helps to have quick header settings in HTTP requests
#
class ReducedScore
  SCORE_REDUCING = 16

  def initialize
    @file = Zoldy.app.stores_dir.join 'reduced_score'
  end

  def fetch
    File.read file
  rescue Errno::ENOENT
    ''
  end

  def score
    Zold::Score.parse_text fetch
  end

  def store(score)
    File.write file, score.reduced(SCORE_REDUCING).to_text
  end

  private

  attr_reader :file

  def score_valid?(score)
    score.valid? && !score.expired? && score.value >= Protocol::MIN_SCORE_VALUE
  end
end
