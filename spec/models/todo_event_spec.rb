require 'rails_helper'

describe TodoEvent, :type => :model do
	let(:todo) { FactoryGirl.create(:todo) }
  let(:user) { FactoryGirl.create(:user) }
  let(:user1) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }
  let(:project) { FactoryGirl.create(:project) }
  let(:event) { FactoryGirl.create(:event) }
  let(:comment) { FactoryGirl.create(:comment) }


  it "should no save invalid user_id" do
    expect(FactoryGirl.build(:event, :user_id => 0).valid?).not_to be_truthy
  end

  it "test TodoEvent.require" do
  	expect(Event.require(nil)).to eq(false)
  	expect(Event.require(nil, user)).to eq(false)
  	expect(Event.require(user)).to eq(true)
  end

  it "should no save invalid todo or user" do
  	expect(TodoEvent.create_todo_create(user, nil)).to eq(nil)
  	expect(TodoEvent.create_todo_create(nil, todo)).to eq(nil)
  	expect(TodoEvent.create_todo_create(nil, nil)).to eq(nil)
  	expect(TodoEvent.create_todo_create(user, todo)).not_to eq(nil)

  	# ...
  end

  it "should save todo_create event correctly" do
  	e = TodoEvent.create_todo_create(user, todo)
  	expect(e.action).to eq('todo_create')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("title")
  	expect(e.params[:project_name]).to eq("project")
  end

  it "should save todo_complete event correctly" do
  	e = TodoEvent.create_todo_complete(user, todo)
  	expect(e.action).to eq('todo_complete')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("title")
  	expect(e.params[:project_name]).to eq("project")
  end

  it "should save todo_delete event correctly" do
  	e = TodoEvent.create_todo_delete(user, todo)
  	expect(e.action).to eq('todo_delete')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("title")
  	expect(e.params[:project_name]).to eq("project")
  end

  it "should save todo_update event correctly" do
  	old_title = todo.title 
  	todo.title = 'new_title'
  	e = TodoEvent.create_todo_update(user, old_title, todo)
  	expect(e).not_to eq(nil)
  	expect(e.action).to eq('todo_update')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("new_title")
  	expect(e.params[:project_name]).to eq("project")
  	expect(e.params[:old_todo_title]).to eq(old_title)
  end

  it "should save todo_assign_to_user event correctly" do
  	e = TodoEvent.create_todo_assign_to_user(user, user1, todo)
  	expect(e).not_to eq(nil)
  	expect(e.action).to eq('todo_assign_to_user')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("title")
  	expect(e.params[:project_name]).to eq("project")
  	expect(e.params[:user_name]).to eq(user1.name)
  end

  it "should save todo_update_assigned_user event correctly" do
  	e = TodoEvent.create_todo_update_assigned_user(user, user, user1, todo)
  	expect(e).not_to eq(nil)
  	expect(e.action).to eq('todo_update_assigned_user')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("title")
  	expect(e.params[:project_name]).to eq("project")
  	expect(e.params[:old_user_name]).to eq(user.name)
  	expect(e.params[:new_user_name]).to eq(user1.name)

  	e1 = TodoEvent.create_todo_update_assigned_user(user, user, nil, todo)
  	expect(e1).not_to eq(nil)
  	expect(e1.action).to eq('todo_update_assigned_user')
  	expect(e1.params.empty?).to eq(false)
  	expect(e1.params[:todo_title]).to eq("title")
  	expect(e1.params[:project_name]).to eq("project")
  	expect(e1.params[:old_user_name]).to eq(user.name)
  	expect(e1.params[:new_user_name]).to eq(nil)
  end

  it "should save todo_update_deadline event correctly" do
  	old_date = todo.deadline
  	todo.deadline = DateTime.now
  	e = TodoEvent.create_todo_update_deadline(user, old_date, todo)
  	expect(e).not_to eq(nil)
  	expect(e.action).to eq('todo_update_deadline')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("title")
  	expect(e.params[:project_name]).to eq("project")
  	expect(e.params[:old_deadline]).to eq(old_date)
  	expect(e.params[:new_deadline]).to eq(todo.deadline)
  end

  it "should save todo_add_comment event correctly" do 
  	e = TodoEvent.create_todo_add_comment(user, comment)
  	expect(e).not_to eq(nil)
  	expect(e.action).to eq('todo_add_comment')
  	expect(e.params.empty?).to eq(false)
  	expect(e.params[:todo_title]).to eq("title")
  	expect(e.params[:project_name]).to eq("project")
  	expect(e.params[:comment_id]).to eq(comment.id)
  	expect(e.params[:comment_content]).to eq(comment.content)
  end

end