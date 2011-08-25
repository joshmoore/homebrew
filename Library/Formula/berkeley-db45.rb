require 'formula'

class BerkeleyDb45 < Formula
  url 'http://download.oracle.com/berkeley-db/db-4.5.20.tar.gz'
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  md5 'b0f1c777708cb8e9d37fb47e7ed3312d'

  keg_only "Older version"

  def options
    [['--without-java', 'Compile without Java support.']]
  end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    ENV.O3 # takes an hour or more with link time optimisation

    args = ["--disable-debug",
            "--prefix=#{prefix}", "--mandir=#{man}",
            "--enable-cxx"]
    args << "--enable-java" unless ARGV.include? "--without-java"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    Dir.chdir 'build_unix' do
      system "../dist/configure", *args
      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix+'docs', doc
    end
  end
end
