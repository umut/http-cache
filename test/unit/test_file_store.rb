$:.unshift "#{File.dirname(__FILE__)}/../../lib"

require 'test/unit'
require 'hoydaa/file_store'

class FileStoreTest < Test::Unit::TestCase

  def test_should_calculate_paths_based_on_ids
    store = Hoydaa::FileStore.new("/home/umut/", 5)
    assert_equal store.calculate_file_path("deneme1"), '/home/umut/7b/3f/f3/3f/66/7b3ff33f66a175b61808b06de7f7e5eb'

    store.folder_count = 4
    assert_equal store.calculate_file_path("deneme2"), '/home/umut/0e/fe/53/36/0efe53366e7e886c9203698b425ee8bf'

    store.root_dir = '/home/umut'
    assert_equal store.calculate_file_path("deneme2"), '/home/umut/0e/fe/53/36/0efe53366e7e886c9203698b425ee8bf'

    store.root_dir = nil
    assert_equal store.calculate_file_path("deneme2"), '/tmp/0e/fe/53/36/0efe53366e7e886c9203698b425ee8bf'
  end

  def test_should_read_file_from_filesystem
    file = File.open("/tmp/deneme.txt", "w")
    file.write("deneme")
    file.close

    assert_equal "deneme", Hoydaa::FileStore.new.read_file("/tmp/deneme.txt")
  end

  def test_should_store_content_as_a_file
    store = Hoydaa::FileStore.new
    store.store("deneme1", "deneme1")

    assert_not_nil File.exists?("/tmp/7b/3f/f3/3f/7b3ff33f66a175b61808b06de7f7e5eb")
    assert_equal "deneme1", IO.read("/tmp/7b/3f/f3/3f/7b3ff33f66a175b61808b06de7f7e5eb")
    assert_equal "deneme1", store.retrieve("deneme1")
    assert_nil store.retrieve("deneme2")
  end

  def test_should_remove_file_when_removed_from_store
    store = Hoydaa::FileStore.new
    store.store("deneme1", "deneme1")

    assert_equal "deneme1", store.retrieve("deneme1")

    store.remove("deneme1")

    assert_nil store.retrieve("deneme1")
  end

  def test_should_give_files_last_modification_date
    store = Hoydaa::FileStore.new
    store.store("deneme1", "deneme1"); sleep 2

    time1 = store.last_modified("deneme1")

    store.store("deneme1", "deneme11")

    time2 = store.last_modified("deneme1")

    assert_not_equal time2, time1
  end

end