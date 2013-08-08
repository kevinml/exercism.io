class Stash 

  attr_reader :user, :code, :language
  def initialize(user, code, filename, curriculum = Exercism.current_curriculum)
    @user = user
    @code = code
    @language = curriculum.identify_language(filename)
  end

  def submission
  	@submission ||= Submission.on(exercise)
  end

  def save
    user.submissions_on(exercise).each do |sub|
      sub.supersede_stash!
    end
    s = user.submissions.select{ |submission| submission.state == 'stashed' }
  	submission.state = 'stashed'
  	submission.code = code
  	user.submissions << submission
    user.save
  	self
  end

  def loot
    submission.code = self.get_code
    self
  end

  def get_code
    user.submissions_on(exercise).each do |sub|
      sub.code if sub.stashed?
    end
  end

  private

  def exercise
    @exercise ||= user.current_on(language)
  end

end