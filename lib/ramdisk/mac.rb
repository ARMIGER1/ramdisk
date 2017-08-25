module Ramdisk
  class Mac
    attr_accessor :disk_name

    def initialize(disk_name: "Untitled")
      @disk_name = disk_name
    end

    def self.sector_size
      Ramdisk.sector_size
    end

    def calculate_size(size_in_gigabytes)
      (size_in_gigabytes * bytes_to_gb) / Ramdisk::Mac.sector_size
    end

    private

    def bytes_to_gb
      1024 ** 3
    end
  end
end
