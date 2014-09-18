require 'rails_helper'

describe TodosController, :type => :controller do
  render_views
  let(:todo) { FactoryGirl.create(:todo) }
  let(:todo1) { FactoryGirl.create(:todo) }
  let(:user) { FactoryGirl.create(:user) }
  let(:user1) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:comment) { FactoryGirl.create(:comment) }

  describe ":todo" do
  	it "should have a show action" do
  		sign_in user
  		get :show, :id => todo.id
  		expect(response).to be_success
  	end

  	it "should not allow anonymous access" do
  		get :show, :id => todo.id
      expect(response).not_to be_success
    end

    it "should allow access from authenticated user" do
      sign_in user
      get :show, :id => todo.id
      expect(response).to be_success
    end

    # 主要测试几个产生事件动态的action

    # 创建todo
    it "should have a correct create action" do
  		sign_in user
  		post :create, :todo => { title: 'title', project_id: project.id, status: 0}, :format => :json
  		expect(response).to be_success
  		t = Todo.last
  		expect(t).to be_truthy
  		expect(t.events.length).to eq(1)
  		e = t.events.first
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_create')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.eventable).to eq(t)
  		expect(e.ownerable).to eq(t.project)
  		expect(e.params[:project_name]).to eq(t.project.name)
  	end

  	it "should have a correct update action" do 
  		sign_in user
  		old_title = todo.title
  		put :update, :id => todo.id, :todo => { title: 'new title' }, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.events.length).to eq(1)
  		e = t.events.first
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_update')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.params[:project_name]).to eq(t.project.name)
  		expect(e.eventable).to eq(t)
  		expect(e.ownerable).to eq(t.project)
  		expect(e.params[:old_todo_title]).to eq(old_title)
  	end

  	it "should have a correct complete action" do
  		sign_in user
  		put :complete, :id => todo.id, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.status).to eq('completed')
  		expect(t.events.length).to eq(1)
  		e = t.events.first
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_complete')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.params[:project_name]).to eq(t.project.name)
  		expect(e.eventable).to eq(t)
  		expect(e.ownerable).to eq(t.project)
  	end

  	it "should have a correct delete action" do
  		sign_in user
  		delete :destroy, :id => todo.id, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.status).to eq('deleted')
  		expect(t.events.length).to eq(1)
  		e = t.events.first
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_delete')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.params[:project_name]).to eq(t.project.name)
  		expect(e.eventable).to eq(t)
  		expect(e.ownerable).to eq(t.project)
  	end

  	it "should have a correct update (assign_user) action" do
  		sign_in user 
  		put :update, :id => todo.id, :todo => { assign_user_id: user1.id.to_s }, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.events.length).to eq(1)
  		e = t.events.first
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_assign_to_user')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.params[:project_name]).to eq(t.project.name)
  		expect(e.params[:user_name]).to eq(user1.name)
  		expect(e.eventable).to eq(t)
  		expect(e.ownerable).to eq(t.project)

  		put :update, :id => todo.id, :todo => { assign_user_id: '' }, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.events.length).to eq(2)
  		e = t.events.second
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_update_assigned_user')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.params[:project_name]).to eq(t.project.name)
  		expect(e.params[:new_user_name]).to eq(nil)
  		expect(e.params[:old_user_name]).to eq(user1.name)

  		t.assign_user_id = user1.id
  		t.save
  		put :update, :id => todo.id, :todo => { assign_user_id: user.id.to_s }, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.events.length).to eq(3)
  		e = t.events.last
  		expect(e).to be_truthy
  		expect(e.params[:new_user_name]).to eq(user.name)
  		expect(e.params[:old_user_name]).to eq(user1.name)
  	end


  	it "should have a correct update (update_deadline) action" do
  		sign_in user 
  		new_date = DateTime.now
  		put :update, :id => todo.id, :todo => { deadline: new_date.to_s }, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.events.length).to eq(1)
  		e = t.events.first
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_update_deadline')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.params[:project_name]).to eq(t.project.name)
  		expect(e.params[:new_deadline].to_i).to eq(new_date.to_i)
  		expect(e.params[:old_deadline]).to eq(nil)
  		expect(e.eventable).to eq(t)
  		expect(e.ownerable).to eq(t.project)

  		new_date1 = DateTime.now + 1.days
  		put :update, :id => todo.id, :todo => { deadline: new_date1.to_s }, :format => :json
  		expect(response).to be_success
  		t = Todo.find(todo.id)
  		expect(t).to be_truthy
  		expect(t.events.length).to eq(2)
  		e = t.events.last
  		expect(e).to be_truthy
  		expect(e.params.empty?).to eq(false)
  		expect(e.action).to eq('todo_update_deadline')
  		expect(e.params[:todo_title]).to eq(t.title)
  		expect(e.params[:project_name]).to eq(t.project.name)
  		expect(e.params[:new_deadline].to_i).to eq(new_date1.to_i)
  		expect(e.params[:old_deadline].to_i).to eq(new_date.to_i)
  		expect(e.eventable).to eq(t)
  		expect(e.ownerable).to eq(t.project)

  	end

  end

end