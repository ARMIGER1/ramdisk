require "ramdisk/version"
require "ramdisk/mac"

module Ramdisk
  DEFAULT_SECTOR_SIZE = 512

  def self.sector_size(size = DEFAULT_SECTOR_SIZE)
    size
  end
end
