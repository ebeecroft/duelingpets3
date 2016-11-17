class Sound < ActiveRecord::Base
   attr_accessible :name, :description, :ogg, :wav, :mp3, :remote_ogg_url, :remote_mp3_url, :remote_wav_url, :ogg_cache, :wav_cache, :mp3_cache
   belongs_to :user
   belongs_to :subsheet
   mount_uploader :ogg, OggUploader
   mount_uploader :mp3, Mp3Uploader
   mount_uploader :wav, WavUploader
   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :name, presence: true, format: {with: VALID_NAME, case_sensitive: false}
   validates :description, presence: true
end
