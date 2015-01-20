require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path 
    assert_template 'static_pages/home'
    # Rails automatically inserts the value of the path name (help_path, etc) in place 
    # of the question mark.  There are two links to home/root on the page and we are 
    # testing that they are both there. 
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
  end
end
