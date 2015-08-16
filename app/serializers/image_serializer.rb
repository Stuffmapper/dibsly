class ImageSerializer < ActiveModel::Serializer
  attributes :thumbnail, :id

  def thumbnail
    object.image.url(:thumbnail)
  end

end
