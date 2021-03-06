# arith.h is built during compilation using arithchk.c
add_executable(arithchk EXCLUDE_FROM_ALL arithchk.c)
target_compile_definitions(arithchk PRIVATE NO_FPINIT)  # maybe also NO_LONG_LONG?
if (NOT MSVC)
  target_link_libraries(arithchk PRIVATE m)
endif()

add_custom_command(
  OUTPUT arith.h
  COMMENT "Generating arith.h for f2c..."
  COMMAND arithchk > ${CMAKE_CURRENT_BINARY_DIR}/arith.h
  DEPENDS arithchk
  VERBATIM
)

# Declare the files needed to compile our vendored f2c copy
add_library(
  f2c_vendored
  STATIC
  EXCLUDE_FROM_ALL
  abort_.c	  dolio.c	    r_sin.c
  dummy.c	  dtime_.c	    iio.c	      r_sinh.c
  backspac.c	  due.c	    ilnw.c	      r_sqrt.c
  c_abs.c	  ef1asc_.c	    inquire.c     r_tan.c
  c_cos.c	  ef1cmc_.c	    l_ge.c	      r_tanh.c
  c_div.c	  endfile.c	    l_gt.c	      rdfmt.c
  c_exp.c	  erf_.c	    l_le.c	      rewind.c
  c_log.c	  erfc_.c	    l_lt.c	      rsfe.c
  c_sin.c	  err.c	    lbitbits.c    rsli.c
  c_sqrt.c	  etime_.c	    lbitshft.c    rsne.c
  cabs.c	  exit_.c	    lread.c	      s_cat.c
  close.c	  f77_aloc.c    lwrite.c      s_cmp.c
  ctype.c	  f77vers.c	    s_copy.c
  d_abs.c	  fmt.c	    open.c	      s_paus.c
  d_acos.c	  fmtlib.c	    pow_ci.c      s_rnge.c
  d_asin.c	  ftell_.c	    pow_dd.c      s_stop.c
  d_atan.c	  pow_di.c      sfe.c
  d_atn2.c	  getenv_.c	    pow_hh.c      sig_die.c
  d_cnjg.c	  h_abs.c	    pow_ii.c      signal_.c
  d_cos.c	  h_dim.c	    pow_ri.c      signbit.c
  d_cosh.c	  h_dnnt.c	    pow_zi.c      sue.c
  d_dim.c	  h_indx.c	    pow_zz.c      system_.c
  d_exp.c	  h_len.c	    r_abs.c	      typesize.c
  d_imag.c	  h_mod.c	    r_acos.c      uio.c
  d_int.c	  h_nint.c	    r_asin.c      uninit.c
  d_lg10.c	  h_sign.c	    r_atan.c      util.c
  d_log.c	  hl_ge.c	    r_atn2.c      wref.c
  d_mod.c	  hl_gt.c	    r_cnjg.c      wrtfmt.c
  d_nint.c	  hl_le.c	    r_cos.c	      wsfe.c
  d_prod.c	  hl_lt.c	    r_cosh.c      wsle.c
  d_sign.c	  i77vers.c	    r_dim.c	      wsne.c
  d_sin.c	  i_abs.c	    r_exp.c	      xwsne.c
  d_sinh.c	  i_dim.c	    r_imag.c      z_abs.c
  d_sqrt.c	  i_dnnt.c	    r_int.c	      z_cos.c
  d_tan.c	  i_indx.c	    r_lg10.c      z_div.c
  d_tanh.c	  i_len.c	    r_log.c	      z_exp.c
  derf_.c	  i_mod.c	    r_mod.c	      z_log.c
  derfc_.c	  i_nint.c	    r_nint.c      z_sin.c
  dfe.c	  i_sign.c	    r_sign.c      z_sqrt.c
  ${CMAKE_CURRENT_BINARY_DIR}/arith.h
)
target_include_directories(
  f2c_vendored
  PUBLIC
  ${CMAKE_SOURCE_DIR}/include
  ${CMAKE_SOURCE_DIR}/src
  ${CMAKE_BINARY_DIR}/src
  PRIVATE
  ${CMAKE_SOURCE_DIR}/src/f2c
  ${CMAKE_BINARY_DIR}/src/f2c
)

if (MSVC)
  target_compile_definitions(f2c_vendored PRIVATE MSDOS)
  target_include_directories(
    f2c_vendored
    PUBLIC
    ${CMAKE_SOURCE_DIR}/msvc/include
  )
endif()

# Suppress some warnings that occur in the output because we do not want to
# mess around with the source of f2c too much to fix these
if(NOT MSVC)
  target_compile_options(arithchk PRIVATE -Wno-format-zero-length)
  target_compile_options(
    f2c_vendored PRIVATE -Wno-parentheses -Wno-format-zero-length
    -Wno-pointer-to-int-cast -Wno-implicit-function-declaration
  )
endif()
