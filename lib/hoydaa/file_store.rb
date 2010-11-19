require 'rubygems'
require 'digest/md5'
require 'tmpdir'

module Hoydaa

  # Hoydaa::FileStore is a basic file repository that can store given string content
  # on the filesystem according and generates optimized paths using the given id.
  #
  # Example:
  #
  #    repo = Hoydaa::FileStore.new
  #    repo.store("id-of-the-resource", "content of the resource")
  #    repo.retrieve("id-of-the-resource")
  #
  # The code given below will store it as a file like the following
  #
  #    /tmp/7b/3f/f3/3f/7b3ff33f66a175b61808b06de7f7e5eb
  #
  # You can also specify the root directory for the repository and the number of levels
  # for directories.
  #
  # Example:
  #
  #    repo = Hoydaa::FileStore.new("/home/app", 5)
  #    repo.root_dir = "/home/app"
  #    repo.folder_count = 5
  #
  class FileStore

    attr_accessor :root_dir, :folder_count

    def initialize(root_dir = nil, folder_count = 4)
      self.root_dir     = root_dir
      self.folder_count = folder_count
    end

    def clear_cache
      # add logic to clear everything under root_dir
    end

    def last_modified(id)
      file_path = calculate_file_path(id)
      return File::mtime(file_path).to_f if File.exist?(file_path)
      0
    end

    def remove(id)
      File.delete(calculate_file_path(id)) if File.exist?(calculate_file_path(id))
    end

    def store(id, content)
      file_path = calculate_file_path(id)
      FileUtils.mkpath File.join(file_path.split("/")[0, file_path.split("/").length-1])
      file = File.open(file_path, "w")
      file.write(content)
      file.close
    end

    def retrieve(id)
      read_file(calculate_file_path(id))
    end

    def read_file(file_path)
      File::exists?(file_path) ? IO.readlines(file_path).join("") : nil
    end

    def calculate_file_path(id)
      hash = Digest::MD5.hexdigest(id)
      File.join(hash.scan(/.{2}|.+/)[0, folder_count].push(hash).insert(0, root_dir==nil ? Dir.tmpdir : root_dir))
    end

  end

end