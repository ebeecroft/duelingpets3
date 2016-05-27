class AddDocumentToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :document, :string
  end
end
