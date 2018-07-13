require "capybara/rspec"
require "./app"
require "pry"
require('spec_helper')

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe 'the project creation path', {:type => :feature} do
  it 'takes the user to the homepage where they can create a project' do
    visit '/'
    fill_in('title', :with => 'Teaching Kids to Code')
    click_button('Add Project')
    expect(page).to have_content('Teaching Kids to Code')
  end
  it 'volunteer form wont be present when there are no projects' do
    visit '/'
    expect(page).to have_content('Please create a project to add volunteers')
  end
end
describe 'project detail path', {:type => :feature} do
  it 'creates a project, goes to the project, and updates project title' do
    visit '/'
    fill_in('title', :with => 'Teaching Kids to Code')
    click_button('Add Project')
    click_link('Teaching Kids to Code')
    fill_in('new_title', :with => 'Teaching Kids to Cook')
    click_button('Update')
    expect(page).to have_content('Teaching Kids to Cook')
  end
  it 'deletes project' do
    visit '/'
    fill_in('title', :with => 'Teaching Kids to Code')
    click_button('Add Project')
    click_link('Teaching Kids to Code')
    click_button('Delete')
    expect(page).to have_no_content('Teaching Kids Code')
  end
end
