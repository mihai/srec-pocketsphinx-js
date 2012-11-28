bin_PROGRAMS = \
	pocketsphinx_batch \
	pocketsphinx_continuous \
	pocketsphinx_mdef_convert \
	srec_file \
  test_raw_ps

pocketsphinx_mdef_convert_SOURCES = mdef_convert.c
pocketsphinx_mdef_convert_LDADD = \
	$(top_builddir)/src/libpocketsphinx/libpocketsphinx.la

pocketsphinx_batch_SOURCES = batch.c
pocketsphinx_batch_LDADD = \
	$(top_builddir)/src/libpocketsphinx/libpocketsphinx.la

pocketsphinx_continuous_SOURCES = continuous.c
pocketsphinx_continuous_LDADD = \
	$(top_builddir)/src/libpocketsphinx/libpocketsphinx.la -lsphinxad

srec_file_SOURCES = srec_file.c
srec_file_LDADD = \
	$(top_builddir)/src/libpocketsphinx/libpocketsphinx.la -lsphinxad

test_raw_ps_SOURCES = test_raw_ps.c
test_raw_ps_LDADD = \
  $(top_builddir)/src/libpocketsphinx/libpocketsphinx.la -lsphinxad

INCLUDES = -I$(top_srcdir)/include \
	-I$(top_srcdir)/src/libpocketsphinx \
	-I$(top_builddir)/include
