build_dir = ./build
pkg_dir = ./build/plugin
torquebox_url="http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-dist/2.1.2/torquebox-dist-2.1.2-bin.zip"
jruby_url="http://jruby.org.s3.amazonaws.com/downloads/1.7.0.RC2/jruby-bin-1.7.0.RC2.zip"

torquebox_home=./torquebox2
jboss_home=$(torquebox_home)/jboss
jruby_home=$(torquebox_home)/jruby

compile:
	mkdir -p $(build_dir)

	@if [ -e $(build_dir)/torquebox.zip ]; then \
	   echo "Skipping torquebox download"; \
	else \
	  echo "Downloading torquebox...from $(torquebox_url)"; \
		curl $(torquebox_url) > $(build_dir)/torquebox.zip; \
	fi

	rm -fr torquebox2

	unzip -d . $(build_dir)/torquebox.zip; \
	mv ./torquebox-2* torquebox2; \

	@if [ -e $(build_dir)/jruby-1.7RC2.zip ]; then \
		echo "Skipping JRuby-1.7 download"; \
	else \
		echo "Downloading JRuby1.7"; \
		curl $(jruby_url) > $(build_dir)/jruby-1.7RC2.zip; \
	fi

	unzip -d . $(build_dir)/jruby-1.7RC2.zip; \
	echo "Overiding JRuby1.6 - has problems with base torquebox2"; \
	cp -R ./jruby-1.7*/* torquebox2/jruby/; \
	rm -fr ./jruby-1.7*; \

	PATH=$(jruby_home)/bin:$(PATH); \
	echo "PATH=$(PATH)"; \


package: compile
	zip $(build_dir)/torquebox2-plugin.zip -r control server setup torquebox2 functions

clean:
	rm -rf $(build_dir)
	rm -rf torquebox2

