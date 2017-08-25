module Ramdisk
  class Mac
    attr_accessor :disk_name, :disk_size, :location

    def initialize(disk_name: "Untitled", disk_size_in_gb: 2)
      @disk_name = disk_name
      @disk_size = calculate_size(disk_size_in_gb)
    end

    def self.sector_size
      Ramdisk.sector_size
    end

    def create
      regex = /(\t|\ )/
      command = "hdiutil attach -nomount ram://#{@disk_size}"

      @location = `#{command}`.gsub(regex, '').chomp
    end

    private

    def calculate_size(size_in_gigabytes)
      (size_in_gigabytes * bytes_to_gb) / Ramdisk::Mac.sector_size
    end

    def bytes_to_gb
      1024 ** 3
    end
  end
end
