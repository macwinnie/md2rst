# md2rst

This repo holds the Dockerfile to support phpDocumentor and translate `md` (MarkDown) files into `rst` (reStructuredText) files.

## environmental variables

| variable name | default | description |
| ------------- | ------- | ----------- |
| `FROM_DIR`    | `/data` | directory where the script reads sources from |
| `TO_DIR`      | `/data` | directory where the script writes transformed data to |
| `DEBUG`       | `FALSE` | should log messages be printed? |
| `TOCED_INDEX` | `TRUE`  | should index files (with table of content) be created if they do not exist and if they exist should a TOC be inserted? |
| `TOC_ATTRS`   | `{"maxdepth":"3","hidden":""}` | JSON representation of dictionary with [attributes for toctree inserted into index files](https://www.sphinx-doc.org/en/1.4.9/markup/toctree.html). <br/><br/>Special attributes: <ul><li>`.named` (root level only) – if you want to define attributes at the dedicated path, you can put `path/to/depth` named dictionaries here.</li><li>`.leveled` (root level only) – you may define attributes by path depth level. `TO_DIR` defines level `0`.</li><li>`.prepend` – define with any (also empty) value to prepend the `index.rst` file by TOC instead of append it.</li></ul>Special attributes override general ones and `.named` one overrides `.leveled` ones. `.named` and `.leveled` have their root (level `0`) in `TO_DIR`. |

## example run command

Given an example data structure like that:

```
./md
 ├── amet.md
 ├── dolor
 │   ├── index.md
 │   └── sadipscing.md
 ├── lorem
 │   ├── index.md
 │   └── ipsum
 │       └── consetetur.md
 └── sit
     └── elitr.md
```

<details>
    <summary style="cursor:pointer; outline: none;">Click for bash code to generate this structure ...</summary>

```sh
mkdir -p md/lorem/ipsum \
         md/dolor \
         md/sit

touch md/amet.md \
      md/lorem/index.md \
      md/lorem/ipsum/consetetur.md \
      md/dolor/sadipscing.md \
      md/sit/elitr.md

cat <<EOF > md/dolor/index.md
# Demo index

This index file is a first demonstration file.
EOF

cat <<EOF > md/lorem/index.md
# Demo index

This index file is a second demonstration file.
EOF
```

</details>

And running the docker image like that:

```sh
read -r -d '' TOCJSON <<- EOV
    {
        ".named": {
            "dolor": {
                ".prepend": ""
            },
            "lorem": {
                "maxdepth": "1"
            }
        },
        ".leveled": {
            "0": {
                "caption": "Table of contents",
                "maxdepth": "3",
                "hidden": ""
            }
        },
        "maxdepth": "3",
        "hidden": ""
    }
EOV

docker run --rm -t \
    -v $(pwd)/md:/dataMd   -e FROM_DIR="/dataMd" \
    -v $(pwd)/rst:/dataRst -e TO_DIR="/dataRst"  \
    -e TOC_ATTRS="${TOCJSON}" \
    macwinnie/md2rst:latest
```

Will result in this file structure:

```
./rst
 ├── amet.rst
 ├── index.rst
 ├── dolor
 │   ├── index.rst
 │   └── sadipscing.rst
 ├── lorem
 │   ├── index.rst
 │   └── ipsum
 │       ├── consetetur.rst
 │       └── index.rst
 └── sit
     ├── elitr.rst
     └── index.rst
```

<details>
    <summary style="cursor:pointer; outline: none;">Click to show generated index files ...</summary><ul>

<li> `rst/index.rst`

```
.. toctree::
   :caption: Table of contents
   :maxdepth: 3
   :hidden:

   amet
   dolor/index
   lorem/index
   sit/index
```

</li><li> `rst/dolor/index.rst`

```
.. toctree::

   sadipscing

Demo index
==========

This index file is a first demonstration file.
```
</li><li> `rst/lorem/index.rst`

```

Demo index
==========

This index file is a second demonstration file.

.. toctree::
   :maxdepth: 1

   ipsum/index
```
</li><li> `rst/lorem/ipsum/index.rst`

```
.. toctree::
   :maxdepth: 3
   :hidden:

   consetetur
```
</li><li> `rst/sit/index.rst`

```
.. toctree::
   :maxdepth: 3
   :hidden:

   elitr
```
</li></ul></details>

If you want to work with the directory levels in a range, you could use e.g. `1..` to define attributes for all levels greater or equal than 1 or `2..3` to define attributes to only be used at 2nd and 3rd levels.

## last built

2024-10-06 23:26:11
