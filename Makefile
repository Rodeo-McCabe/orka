WINDOWING_BACKEND := egl
GLFW_LIBS := $(strip $(shell pkg-config --libs glfw3))

LIBRARY_TYPE ?= relocatable
MODE ?= development

CFLAGS ?= -O2 -march=native

X_WINDOWING_SYSTEM := -XWindowing_System=$(WINDOWING_BACKEND)
X_LIBRARY_TYPE := -XLibrary_Type=$(LIBRARY_TYPE)
X_GLFW_LIBS := -XGLFW_Libs="$(GLFW_LIBS)"

GPRBUILD = nice gprbuild -dm -p $(X_WINDOWING_SYSTEM) $(X_LIBRARY_TYPE) $(X_GLFW_LIBS)
GPRCLEAN = gprclean -q $(X_WINDOWING_SYSTEM)
GPRINSTALL = gprinstall -q $(X_WINDOWING_SYSTEM)

PREFIX ?= /usr

includedir = $(PREFIX)/include
gprdir     = $(PREFIX)/share/gpr
libdir     = $(PREFIX)/lib
alidir     = $(libdir)

installcmd = $(GPRINSTALL) -p \
	--sources-subdir=$(includedir) \
	--project-subdir=$(gprdir) \
	--lib-subdir=$(libdir) \
	--ali-subdir=$(alidir) \
	--prefix=$(PREFIX)

.PHONY: build examples tools tests coverage docs clean install uninstall

build:
	$(GPRBUILD) -P tools/orka-glfw.gpr -XMode=$(MODE) -cargs $(CFLAGS)

build_test:
	$(GPRBUILD) -P tests/unit/tests.gpr -XMode=coverage -cargs -O0 -march=native

examples: build
	$(GPRBUILD) -P tools/examples.gpr -XMode=$(MODE) -cargs $(CFLAGS)

tools: build
	$(GPRBUILD) -P tools/tools.gpr -XMode=$(MODE) -cargs $(CFLAGS)

tests: build_test
	./tests/unit/bin/run_unit_tests

coverage:
	mkdir -p tests/cov
	lcov -q -c -d tests/unit/build/obj -o tests/cov/unit.info
	lcov -q -c -d build/obj/tests -o tests/cov/unit.info
	lcov -q -r tests/cov/unit.info */adainclude/* -o tests/cov/unit.info
	lcov -q -r tests/cov/unit.info */tests/unit/* -o tests/cov/unit.info
	genhtml -q --ignore-errors source -o tests/cov/html tests/cov/unit.info
	lcov -l tests/cov/unit.info

docs:
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs:ro -u $(shell id -u):$(shell id -g) squidfunk/mkdocs-material

clean:
	$(GPRCLEAN) -r -P tools/orka-glfw.gpr
	$(GPRCLEAN) -P tests/unit/tests.gpr
	$(GPRCLEAN) -P tools/examples.gpr
	$(GPRCLEAN) -P tools/tools.gpr
	rm -rf bin build tests/unit/build tests/unit/bin tests/cov

install:
	$(installcmd) --install-name='orka' -P tools/orka.gpr
	$(installcmd) --install-name='orka-glfw' -P tools/orka-glfw.gpr

uninstall:
	$(installcmd) --uninstall --install-name='orka-glfw' -P tools/orka-glfw.gpr
	$(installcmd) --uninstall --install-name='orka' -P tools/orka.gpr
