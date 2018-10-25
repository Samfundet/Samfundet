class ReactModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_new_static_module
    create_file "app/views/static/#{file_name}.html.haml", <<-FILE
= stylesheet_link_tag 'react_styles'
#root
= javascript_include_tag 'react_vendor'
= javascript_include_tag 'react_#{file_name}'
    FILE
  end
end
