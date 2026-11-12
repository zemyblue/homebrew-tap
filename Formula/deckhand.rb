class Deckhand < Formula
  desc "Host app and web simulator for a cmux/Claude Code macro keypad"
  homepage "https://github.com/zemyblue/homebrew-tap"
  url "https://github.com/zemyblue/homebrew-tap/releases/download/v0.1.3b1/deckhand-0.1.3b1.tar.gz"
  sha256 "4ee216e9431a50830f1dde989041bc4305c9a1747818d50b9b78f3cea4664979"

  depends_on arch: :arm64 # Apple silicon only: no Intel bottle is built
  depends_on :macos
  depends_on "python@3.14"

  # pure Python (USB serial link to the keypad): copied in, nothing to build
  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/41/a5/463dc32a6c32cff57b4678298a13cd830d7ab09cfec3d7e80f20a2f414fd/pyobjc_core-13.0-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "fe470bd7b8163b4b8d216b1ebe5b227f01c0fa1c4e0085d7ccade269dec02bb0"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/b4/bb/f683ec329180e1931c8d592c882defebca8810e019cf4bc8727fa36b7d89/pyobjc_framework_cocoa-13.0-cp314-cp314-macosx_10_15_universal2.whl"
    sha256 "88be6d452e7531f695ce6d41428aa74bcaade9ddbc50af592419b9f2fbb7c879"
  end

  def install
    libexec.install "deckhand", "deckhand_core"
    resource("pyserial").stage { libexec.install "serial" }
    # a wheel is a zip of importable files: unpack it next to the packages (no pip, nothing to build)
    %w[pyobjc-core pyobjc-framework-cocoa].each do |r|
      system "unzip", "-q", "-o", resource(r).cached_download, "-d", libexec
    end
    rm_r libexec/"PyObjCTest" # pyobjc's own test suite: not needed to run
    # launch.py sits next to the packages, so Python finds them; -E -s ignores PYTHONPATH and the user's
    # site-packages, so only these files are imported
    (libexec/"launch.py").write <<~PY
      import sys
      from deckhand.cli import main
      sys.exit(main())
    PY
    (bin/"deckhand").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("python@3.14")}/python3.14" -E -s "#{libexec}/launch.py" "$@"
    SH
  end

  # login agent, registered by `deckhand setup` (which first switches cmux to automation mode, with consent)
  service do
    run [opt_bin/"deckhand", "device", "--full", "--wait-cmux", "--menubar"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/deckhand.log"
    error_log_path var/"log/deckhand.log"
  end

  def caveats
    <<~EOS
      Start with the Mac at login (asks first, changes cmux socket access): deckhand setup
      Check the setup:               deckhand doctor
      Simulator without the keypad:  deckhand simulate --web --demo
      Update:                        brew upgrade deckhand
                                     then brew services restart deckhand (or log in again)
      Undo setup:                    deckhand uninstall
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deckhand --version")
    assert_match "--web", shell_output("#{bin}/deckhand simulate --help")
    # the menu bar's AppKit (unpacked pyobjc wheels) imports with the formula's Python
    system formula_opt_bin("python@3.14")/"python3.14", "-E", "-s", "-c",
           "import sys; sys.path.insert(0, '#{libexec}'); import AppKit, PyObjCTools.AppHelper"
  end
end
