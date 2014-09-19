# 这只是一个例子：由文档资源产生的事件
class DocumentEvent < Event
  default_scope -> { where(eventable_type: 'Document') }

  def document
    self.eventable
  end
end