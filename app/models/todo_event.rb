class TodoEvent < Event
  def todo
    self.eventable
  end

	# 添加任务回复事件
  def self.create_todo_add_comment(current_user, comment)
    return nil unless self.require(current_user, comment)
    todo = comment.todo
    todo.events.create(
      ownerable: todo.project,
      user: current_user,
      params: { todo_title: todo.title, comment_id: comment.id, comment_content: comment.content, project_name: todo.project.name },
      action: :todo_add_comment)
  end

  # 创建任务事件
  def self.create_todo_create(current_user, todo)
    return nil unless self.require(current_user, todo)
    todo.events.create(
      user: current_user,
      ownerable: todo.project,
      params: {todo_title: todo.title, project_name: todo.project.name},
      action: :todo_create)
  end

  # 完成了任务
  def self.create_todo_complete(current_user, todo)
    return nil unless self.require(current_user, todo)
    todo.events.create(
      user: current_user,
      ownerable: todo.project,
      params: {todo_title: todo.title, project_name: todo.project.name},
      action: :todo_complete)
  end

  # 修改任务
  def self.create_todo_update(current_user, old_title, todo)
    return nil unless self.require(current_user, todo)
    todo.events.create(
      user: current_user,
      ownerable: todo.project,
      params: {old_todo_title: old_title, todo_title: todo.title, project_name: todo.project.name},
      action: :todo_update)
  end

  # 删除任务
  def self.create_todo_delete(current_user, todo)
    return nil unless self.require(current_user, todo)
    todo.events.create(
      user: current_user,
      ownerable: todo.project,
      params: {todo_title: todo.title, project_name: todo.project.name},
      action: :todo_delete)
  end

  # 指派任务
  def self.create_todo_assign_to_user(current_user, user, todo)
    return nil unless self.require(current_user, todo)
    todo.events.create(
      user: current_user,
      ownerable: todo.project,
      params: {todo_title: todo.title, user_name: user.present? ? user.name : nil, project_name: todo.project.name},
      action: :todo_assign_to_user)
  end

  # 修改任务完成者
  def self.create_todo_update_assigned_user(current_user, old_user, new_user, todo)
    return nil unless self.require(current_user, todo, old_user)
    todo.events.create(
      user: current_user,
      ownerable: todo.project,
      params: {todo_title: todo.title, old_user_name: old_user.name, new_user_name: new_user.present? ? new_user.name : nil , project_name: todo.project.name},
      action: :todo_update_assigned_user)
  end

  # 修改任务完成时间
  def self.create_todo_update_deadline(current_user, old_date, todo)
    return nil unless self.require(current_user, todo)
    todo.events.create(
      user: current_user,
      ownerable: todo.project,
      params: {todo_title: todo.title, old_deadline: old_date, new_deadline: todo.deadline, project_name: todo.project.name},
      action: :todo_update_deadline)
  end
end