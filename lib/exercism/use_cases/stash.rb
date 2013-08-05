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
  	submission.state = 'stashed'
  	submission.code = code
  	user.submissions << submission
    user.save
  	self
  end

  def loot
    user.submissions_on(exercise).each do |sub|
      return sub if self.stashed?
    end
  end

  private

  def exercise
    @exercise ||= user.current_on(language)
  end

end