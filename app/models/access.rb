class Access < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :project

  # 可能要用的权限级别，这里demo就不用了
  enumerize :privilege, in: {
    normal:    0,  # 普通权限
    admin:     1,  # 管理权限
    }, scope: :with_privilege, default: :normal, i18n_scope: "access"
end
