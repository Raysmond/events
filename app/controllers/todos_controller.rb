class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :complete]

  # GET /todos
  # GET /todos.json
  def index
    @todos = Todo.all
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
    @project = @todo.project
  end

  # PUT /todos/1/complete
  def complete
    @todo.update_attribute(:status, :completed)
    event_todo_complete(@todo)
    respond_to do |format|
      format.html { redirect_to @todo.project, notice: '完成了任务' }
      format.json { render :show, status: :ok, location: @todo  }
    end
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(todo_params)
    @todo.creator = current_user
    if todo_params[:assign_user_id].present? and not todo_params[:assign_user_id].empty?
      @todo.assign_by_user = current_user
    end

    respond_to do |format|
      if @todo.save
        event_todo_create @todo
        format.html { redirect_to @todo.project, notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    respond_to do |format|
      if todo_params[:assign_user_id].present? and not todo_params[:assign_user_id].empty?
        @todo.assign_by_user = current_user
      end
      old_title = @todo.title
      old_user = @todo.assign_user
      old_deadline = @todo.deadline
      if @todo.update(todo_params)
        # 修改任务
        event_todo_update(old_title, @todo) if @todo.title != old_title
        # 指派任务
        event_todo_assign_to_user(@todo.assign_user, @todo) if !old_user.present? and @todo.assign_user.present?
        # 修改任务完成者
        event_todo_update_assigned_user(old_user, @todo.assign_user, @todo) if old_user.present? and old_user.id != @todo.assign_user.id
        # 修改任务完成时间
        event_todo_update_deadline(old_deadline, @todo) if old_deadline != @todo.deadline

        format.html { redirect_to @todo.project, notice: 'Todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    # @todo.destroy
    @todo.update_attribute(:status, :deleted)
    event_todo_delete(@todo)
    respond_to do |format|
      format.html { redirect_to @todo.project, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :assign_user_id, :deadline, :project_id)
    end

    # 创建任务事件
    def event_todo_create(todo)
      todo.events.create(
        user: current_user,
        title: "创建了任务：#{view_context.link_to todo.title, todo_path(todo)}",
        owner: "#{view_context.link_to todo.project.name, project_path(todo.project)}",
        action: :todo_create)
    end

    # 完成了任务
    def event_todo_complete(todo)
      todo.events.create(
        user: current_user,
        title: "完成了任务：#{view_context.link_to todo.title, todo_path(todo)}",
        owner: "#{view_context.link_to todo.project.name, project_path(todo.project)}",
        action: :todo_complete)
    end

    # 修改任务
    def event_todo_update(old_title, todo)
      todo.events.create(
        user: current_user,
        title: "将任务 \"#{old_title}\" 修改为：#{view_context.link_to todo.title, todo_path(todo)}",
        owner: "#{view_context.link_to todo.project.name, project_path(todo.project)}",
        action: :todo_update)
    end

    # 删除任务
    def event_todo_delete(todo)
      todo.events.create(
        user: current_user,
        title: "删除了任务：#{view_context.link_to todo.title, todo_path(todo)}",
        owner: "#{view_context.link_to todo.project.name, project_path(todo.project)}",
        action: :todo_delete)
    end

    # 指派任务
    def event_todo_assign_to_user(user, todo)
      todo.events.create(
        user: current_user,
        title: "给 #{user.name} 指派了任务：#{view_context.link_to todo.title, todo_path(todo)}",
        owner: "#{view_context.link_to todo.project.name, project_path(todo.project)}",
        action: :todo_assign_to_user)
    end

    # 修改任务完成者
    def event_todo_update_assigned_user(old_user, new_user, todo)
      todo.events.create(
        user: current_user,
        title: "把 #{old_user.name} 的任务指派给 #{new_user.name}：#{view_context.link_to todo.title, todo_path(todo)}",
        owner: "#{view_context.link_to todo.project.name, project_path(todo.project)}",
        action: :todo_update_assigned_user)
    end

    # 修改任务完成时间
    def event_todo_update_deadline(old_date, todo)
      old_date = old_date.present? ? old_date.strftime("%m月%d日") : "没有截止日期"
      new_date = todo.deadline.strftime("%m月%d日")
      todo.events.create(
        user: current_user,
        title: "将任务完成时间从 #{old_date} 修改为 #{new_date}：#{view_context.link_to todo.title, todo_path(todo)}",
        owner: "#{view_context.link_to todo.project.name, project_path(todo.project)}",
        action: :todo_update_deadline)
    end

end
