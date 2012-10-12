build_dir = ./build
torquebox_url="http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-dist/2.1.2/torquebox-dist-2.1.2-bin.zip"

compile:
	mkdir -p $(build_dir)

	@if [ -e torquebox2 ]; then \
	   echo "Skipping torquebox download"; \
	else \
	   echo "Downloading torquebox..."; \
	   curl $(torquebox_url) > $(build_dir)/torquebox.zip; \
	   unzip -d . $(build_dir)/torquebox.zip; \
	   mv ./torquebox-2* torquebox2; \
	   export TORQUEBOX_HOME=$(build_dir)/torquebox2; \
		 export JBOSS_HOME=$TORQUEBOX_HOME/jboss; \
		 export JRUBY_HOME=$TORQUEBOX_HOME/jruby; \
		 export PATH=$JRUBY_HOME/bin:$PATH; \
		 echo "Installing torquebox gem"; \
		 jruby -S gem install torquebox
	fi

package: compile
	jar cvf $(build_dir)/torquebox2-plugin.zip control server setup torquebox2

clean:
	rm -rf $(build_dir)
	rm -rf torquebox2

