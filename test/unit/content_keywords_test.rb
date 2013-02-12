require 'test_helper'

class ContentKeywordsTest < ActiveSupport::TestCase


	test "should have 5 search terms" do
  		assert_equal 5, ContentKeywords.all.count, "Should have 5 search terms"
  	end

  	test "should have 4 default search terms" do
  		assert_equal 4, ContentKeywords.where(:default => true).count, "Should have 4 default search terms"
  	end

end
