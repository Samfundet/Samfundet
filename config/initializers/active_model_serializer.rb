# Convert json field names to camelcase
ActiveModel::Serializer.config.key_transform = :camel_lower
ActiveModel::Serializer.config.default_includes = "**"
