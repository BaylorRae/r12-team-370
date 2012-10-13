require 'test_helper'

class GameChallengeTest < ActiveSupport::TestCase
  setup do
    @game = Game.create :username => "jonatasdp"
    @game.start!
    assert @game.next_challenge!
    @game_challenge = GameChallenge.new 
  end
  test "Game can start with an anonymous user" do
    assert @game.valid?
  end
  test "Game should have many challenges" do
    assert_equal 2, @game.game_challenges.size
  end
  test "should validate answers as normal strings" do
    @game_challenge.challenge = Challenge.new :correct_answer => "test"
    assert @game_challenge.valid_answer?("test")
  end

  test "aprove good implementations" do
    @game_challenge.challenge = Challenge.all.second
    oks = [
      "self.match /:\\)|:\\]/", 
      "self.match %r{:\\)|:\\]}"
    ]
    oks.each do |ok|
      assert @game_challenge.valid_answer?(ok), "Implementation #{ok.inspect} doesnt work yet"
    end
  end
  test "keep error on bad code and return false to answer" do
    @game_challenge.challenge = Challenge.all.second
    puts @game_challenge.challenge.code_challenge
    raises = [
      ": )",
      "self-match? /:[)]]/"
    ]
    raises.each do |invalid_code|
      assert_nothing_raised do
        assert ! @game_challenge.valid_answer?(invalid_code)
        assert @game_challenge.last_compiling_error
        assert @game_challenge.last_compiling_error_trace
      end
    end
  end
  teardown do
    @game.destroy
  end
end
