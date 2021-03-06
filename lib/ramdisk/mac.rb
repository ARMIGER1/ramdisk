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

    def for_ios_simulator(app_name: "App")
      device_id_regex = /[0-9A-F]{,8}-[0-9A-F]{,4}-[0-9A-F]{,4}-[0-9A-F]{,4}-[0-9A-F]{,12}/
      path = `find ~/Library/Developer/CoreSimulator -name #{app_name}`.chomp

      ramdisk_name = path.scan(device_id_regex).first
      path = path.split(File::SEPARATOR)
      path = path.take(path.index(ramdisk_name)+1).join(File::SEPARATOR)

      @disk_name = ramdisk_name
      @mount_point = path
      @disk_size = calculate_size(0.5)
    end

    def for_xcode
      derived_data_directory = File.expand_path('~/Library/Developer/Xcode/DerivedData')

      @disk_name = 'DerivedData'
      @mount_point = derived_data_directory
      @disk_size = calculate_size(1)
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
