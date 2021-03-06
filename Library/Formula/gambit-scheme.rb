require 'formula'

class GambitScheme < Formula
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.6/source/gambc-v4_6_2.tgz'
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  md5 'f6230a1f1f56b8113e0b9e391074bcb0'

  def options
    [
      ['--with-check', 'Execute "make check" before installing. Runs some basic scheme programs to ensure that gsi and gsc are working'],
      ['--enable-shared', 'Build Gambit Scheme runtime as shared library']
    ]
  end

  skip_clean :all

  fails_with_llvm "ld crashes during the build process or segfault at runtime", :build => 2335

  def install
    ENV.O2 # Gambit Scheme doesn't like full optimizations

    configure_args = [
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--disable-debug",
      # Recommended to improve the execution speed and compactness
      # of the generated executables. Increases compilation times.
      "--enable-single-host"
    ]

    configure_args << "--enable-shared" if ARGV.include? '--enable-shared'

    system "./configure", *configure_args
    system "make check" if ARGV.include? '--with-check'

    ENV.j1
    system "make"
    system "make install"
  end
end
