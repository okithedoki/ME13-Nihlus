// rust_g.dm - DM API for rust_g extension library
//
// To configure, create a `rust_g.config.dm` and set what you care about from
// the following options:
//
// #define RUST_G "path/to/rust_g"
// Override the .dll/.so detection logic with a fixed path or with detection
// logic of your own.
//
// #define RUSTG_OVERRIDE_BUILTINS
// Enable replacement rust-g functions for certain builtins. Off by default.

#ifndef RUST_G
// Default automatic RUST_G detection.
// On Windows, looks in the standard places for `rust_g.dll`.
// On Linux, looks in `.`, `$LD_LIBRARY_PATH`, and `~/.byond/bin` for either of
// `librust_g.so` (preferred) or `rust_g` (old).

/* This comment bypasses grep checks */ /var/__rust_g

/proc/__detect_rust_g()
	if (world.system_type == UNIX)
		if (fexists("./librust_g.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __rust_g = "./librust_g.so"
		else if (fexists("./rust_g"))
			// Old dumb filename.
			return __rust_g = "./rust_g"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/rust_g"))
			// Old dumb filename in `~/.byond/bin`.
			return __rust_g = "rust_g"
		else
			// It's not in the current directory, so try others
			return __rust_g = "librust_g.so"
	else
		return __rust_g = "rust_g"

#define RUST_G (__rust_g || __detect_rust_g())
#endif

/// Gets the version of rust_g
/proc/rustg_get_version() return LIBCALL(RUST_G, "get_version")()

#define rustg_dmi_strip_metadata(fname) LIBCALL(RUST_G, "dmi_strip_metadata")(fname)
#define rustg_dmi_create_png(path, width, height, data) LIBCALL(RUST_G, "dmi_create_png")(path, width, height, data)
#define rustg_dmi_resize_png(path, width, height, resizetype) LIBCALL(RUST_G, "dmi_resize_png")(path, width, height, resizetype)

#define rustg_file_read(fname) LIBCALL(RUST_G, "file_read")(fname)
#define rustg_file_exists(fname) LIBCALL(RUST_G, "file_exists")(fname)
#define rustg_file_write(text, fname) LIBCALL(RUST_G, "file_write")(text, fname)
#define rustg_file_append(text, fname) LIBCALL(RUST_G, "file_append")(text, fname)

#ifdef RUSTG_OVERRIDE_BUILTINS
	#define file2text(fname) rustg_file_read("[fname]")
	#define text2file(text, fname) rustg_file_append(text, "[fname]")
#endif

#define rustg_git_revparse(rev) LIBCALL(RUST_G, "rg_git_revparse")(rev)
#define rustg_git_commit_date(rev) LIBCALL(RUST_G, "rg_git_commit_date")(rev)

#define rustg_hash_string(algorithm, text) LIBCALL(RUST_G, "hash_string")(algorithm, text)
#define rustg_hash_file(algorithm, fname) LIBCALL(RUST_G, "hash_file")(algorithm, fname)
#define rustg_hash_generate_totp(seed) LIBCALL(RUST_G, "generate_totp")(seed)
#define rustg_hash_generate_totp_tolerance(seed, tolerance) LIBCALL(RUST_G, "generate_totp_tolerance")(seed, tolerance)

#define RUSTG_HASH_MD5 "md5"
#define RUSTG_HASH_SHA1 "sha1"
#define RUSTG_HASH_SHA256 "sha256"
#define RUSTG_HASH_SHA512 "sha512"
#define RUSTG_HASH_XXH64 "xxh64"
#define RUSTG_HASH_BASE64 "base64"

#ifdef RUSTG_OVERRIDE_BUILTINS
	#define md5(thing) (isfile(thing) ? rustg_hash_file(RUSTG_HASH_MD5, "[thing]") : rustg_hash_string(RUSTG_HASH_MD5, thing))
#endif

#define RUSTG_HTTP_METHOD_GET "get"
#define RUSTG_HTTP_METHOD_PUT "put"
#define RUSTG_HTTP_METHOD_DELETE "delete"
#define RUSTG_HTTP_METHOD_PATCH "patch"
#define RUSTG_HTTP_METHOD_HEAD "head"
#define RUSTG_HTTP_METHOD_POST "post"
#define rustg_http_request_blocking(method, url, body, headers, options) LIBCALL(RUST_G, "http_request_blocking")(method, url, body, headers, options)
#define rustg_http_request_async(method, url, body, headers, options) LIBCALL(RUST_G, "http_request_async")(method, url, body, headers, options)
#define rustg_http_check_request(req_id) LIBCALL(RUST_G, "http_check_request")(req_id)

#define RUSTG_JOB_NO_RESULTS_YET "NO RESULTS YET"
#define RUSTG_JOB_NO_SUCH_JOB "NO SUCH JOB"
#define RUSTG_JOB_ERROR "JOB PANICKED"

#define rustg_log_write(fname, text, format) LIBCALL(RUST_G, "log_write")(fname, text, format)
/proc/rustg_log_close_all() return LIBCALL(RUST_G, "log_close_all")()

#define rustg_time_microseconds(id) text2num(LIBCALL(RUST_G, "time_microseconds")(id))
#define rustg_time_milliseconds(id) text2num(LIBCALL(RUST_G, "time_milliseconds")(id))
#define rustg_time_reset(id) LIBCALL(RUST_G, "time_reset")(id)

#define rustg_udp_send(addr, text) LIBCALL(RUST_G, "udp_send")(addr, text)

#define rustg_url_encode(text) LIBCALL(RUST_G, "url_encode")("[text]")
#define rustg_url_decode(text) LIBCALL(RUST_G, "url_decode")(text)

#ifdef RUSTG_OVERRIDE_BUILTINS
	#define url_encode(text) rustg_url_encode(text)
	#define url_decode(text) rustg_url_decode(text)
#endif

