class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :complete]
  before_action :authenticate_user!
  
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
    TodoEvent.create_todo_complete(current_user, @todo)
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
        TodoEvent.create_todo_create current_user, @todo
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
      if todo_params[:assign_user_id].present? and todo_params[:assign_user_id].empty?
        @todo.assign_user_id = nil
        @todo.assign_user = nil
      end
      if @todo.update(todo_params)
        # 修改任务
        TodoEvent.create_todo_update(current_user, old_title, @todo) if @todo.title != old_title
        # 指派任务
        TodoEvent.create_todo_assign_to_user(current_user, @todo.assign_user, @todo) if !old_user.present? and @todo.assign_user.present?
        # 修改任务完成者
        TodoEvent.create_todo_update_assigned_user(current_user, old_user, @todo.assign_user, @todo) if old_user.present? and old_user != @todo.assign_user
        # 修改任务完成时间
        TodoEvent.create_todo_update_deadline(current_user, old_deadline, @todo) if old_deadline != @todo.deadline

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
    TodoEvent.create_todo_delete(current_user, @todo)
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

end
