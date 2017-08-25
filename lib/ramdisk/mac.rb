module Ramdisk
  class Mac
    attr_accessor :disk_name

    def initialize(disk_name: "Untitled")
      @disk_name = disk_name
    end

    def self.sector_size
      Ramdisk.sector_size
    end
  end
end
