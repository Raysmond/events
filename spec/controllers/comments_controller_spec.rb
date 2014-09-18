require 'rails_helper'

describe CommentsController, :type => :controller do
	render_views
	let(:todo) { FactoryGirl.create(:todo) }
	let(:user) { FactoryGirl.create(:user) }
	let(:comment) { FactoryGirl.create(:comment) }

	it "should have a correct add_comment event action" do 
		sign_in user 
		post :create, :comment => { content: 'content', todo_id: todo.id }, :format => :json
		expect(response).to be_success
		c = Comment.last
		expect(c).to be_truthy
		t = c.todo 
		expect(t).to be_truthy
		expect(t).to eq(todo)
		expect(t.events.length).to eq(1)
		e = t.events.first
		expect(e).to be_truthy
		expect(e.params.empty?).to eq(false)
		expect(e.action).to eq('todo_add_comment')
		expect(e.params[:todo_title]).to eq(t.title)
		expect(e.params[:project_name]).to eq(t.project.name)
		expect(e.params[:comment_id]).to eq(c.id)
		expect(e.params[:comment_content]).to eq(c.content)
		expect(e.eventable).to eq(t)
		expect(e.ownerable).to eq(t.project)

	end

end