RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.total_columns_width = 910

  config.model 'Event' do 
    configure :title do
      pretty_value do 
        event = bindings[:object]
        %{#{event.title}}.html_safe
      end
    end

    configure :owner do
      pretty_value do 
        event = bindings[:object]
        %{#{event.owner}}.html_safe
      end
    end

    configure :content do
      pretty_value do 
        event = bindings[:object]
        %{#{event.content}}.html_safe
      end
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
