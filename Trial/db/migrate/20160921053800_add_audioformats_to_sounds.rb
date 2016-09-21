class AddAudioformatsToSounds < ActiveRecord::Migration
  def change
    add_column :sounds, :ogg, :string
    add_column :sounds, :mp3, :string
    add_column :sounds, :wav, :string
  end
end
