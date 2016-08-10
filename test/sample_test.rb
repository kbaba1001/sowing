class SampleTest < TestBase
  test 'hoge' do
    p User.create(first_name: 'kazuki', last_name: 'baba')
    p User.count
  end

  test 'foo' do
    p User.create(first_name: 'kazuki', last_name: 'baba')
    p User.count
  end

  test 'baz' do
    p User.create(first_name: 'kazuki', last_name: 'baba')
    p User.count
  end
end
