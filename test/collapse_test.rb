require File.join(File.dirname(__FILE__), 'test_helper')

class CollapseTest < Test::Unit::TestCase
  context 'Collapsing versions' do
  
    setup do 
      @name = 'Steve Richert'
      @user = User.create(:name => @name)
      @versions = []
      names = ['Steve Richert', 'Stephen Richert', 'Stephen Jobs', 'Steve Jobs']
      names.each do |name|
        @user.update_attributes(:name => name)
        @versions << @user.versions.at(:last)
      end
    end
    
    should "change the version number to target" do
      @user.collapse_versions(4, 2)
      assert_equal 2, @user.version
    end
    
    should "dissasociate the versions after target" do
      @user.collapse_versions(4, 2)
      assert_equal 0, @user.versions(true).after(2).length
    end
    
    should "not change the model" do
      @user.collapse_versions(4,2)
      assert_equal 'Steve Jobs', @user.name
    end
    
    should "merge the changes into the new version" do
      @user.collapse_versions(4,2)
      assert_equal @user.versions.last.changes, {"first_name" => ['Steve', 'Stephen']}
    end
    
    should "keep the last versions time" do
      @user.collapse_versions(4,2)
      assert_equal @user.versions.at(:last).updated_at, @versions.last.updated_at
    end
    
  end

end