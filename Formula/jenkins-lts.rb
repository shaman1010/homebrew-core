class JenkinsLts < Formula
  desc "Extendable open-source CI server"
  homepage "https://jenkins.io/index.html#stable"
  url "http://mirrors.jenkins.io/war-stable/2.107.2/jenkins.war"
  sha256 "079ab885be74ea3dd4d2a57dd804a296752fae861f2d7c379bce06b674ae67ed"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    system "jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/jenkins-cli.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", :java_version => "1.8"
    bin.write_jar_script libexec/"jenkins-cli.jar", "jenkins-lts-cli", :java_version => "1.8"
  end

  def caveats; <<~EOS
    Note: When using launchctl the port will be 8080.
    EOS
  end

  plist_options :manual => "jenkins-lts"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/libexec/java_home</string>
          <string>-v</string>
          <string>1.8</string>
          <string>--exec</string>
          <string>java</string>
          <string>-Dmail.smtp.starttls.enable=true</string>
          <string>-jar</string>
          <string>#{opt_libexec}/jenkins.war</string>
          <string>--httpListenAddress=127.0.0.1</string>
          <string>--httpPort=8080</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.append "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    pid = fork do
      exec "#{bin}/jenkins-lts"
    end
    sleep 60

    begin
      output = shell_output("curl localhost:8080/")
      assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
