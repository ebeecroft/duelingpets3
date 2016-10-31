class Sound < ActiveRecord::Base
   attr_accessible :name, :description, :ogg, :wav, :mp3, :remote_ogg_url, :remote_mp3_url, :remote_wav_url, :ogg_cache, :wav_cache, :mp3_cache
   belongs_to :user
   belongs_to :subsheet
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader
   mount_uploader :wav, WavUploader
   validates :name, presence: true, uniqueness: { case_sensitive: false}
   validates :description, presence: true
end
