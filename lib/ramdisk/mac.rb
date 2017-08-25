module Ramdisk
  class Mac
    attr_accessor :disk_name, :disk_size, :location, :mount_point

    def initialize(disk_name: "RAMDISK", disk_size_in_gb: 2, mount_point: '/Volumes/RAMDISK')
      @disk_name = disk_name
      @disk_size = calculate_size(disk_size_in_gb)
      @mount_point = mount_point
    end

    def self.sector_size
      Ramdisk.sector_size
    end

    def create
      regex = /(\t|\ )/
      command = "hdiutil attach -nomount ram://#{@disk_size}"

      @location = `#{command}`.gsub(regex, '').chomp

      init_disk
      mount
    end

    def destroy
      `hdiutil detach #{@location}`
    end

    private

    def init_disk
      `newfs_hfs -v #{disk_name} #{location}`
    end

    def mount
      `diskutil mount -mountPoint #{@mount_point} #{@location}`
    end

    def calculate_size(size_in_gigabytes)
      (size_in_gigabytes * bytes_to_gb) / Ramdisk::Mac.sector_size
    end

    def bytes_to_gb
      1024 ** 3
    end
  end
end
