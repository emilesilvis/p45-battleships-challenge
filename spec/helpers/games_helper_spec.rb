require 'spec_helper'

describe GamesHelper do

  describe "gravatar_for" do
    it "should respond to size" do
      expect(gravatar_for('test@tester.com', {:size => 40})).to respond_to(:size)
    end
  end
end