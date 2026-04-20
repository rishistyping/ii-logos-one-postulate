#!/usr/bin/env python3
from __future__ import annotations

import copy
import sys
import xml.etree.ElementTree as ET


SVG_NS = "http://www.w3.org/2000/svg"
XLINK_NS = "http://www.w3.org/1999/xlink"

ET.register_namespace("", SVG_NS)
ET.register_namespace("xlink", XLINK_NS)


def svg_tag(name: str) -> str:
    return f"{{{SVG_NS}}}{name}"


def local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def build_parent_map(root: ET.Element) -> dict[ET.Element, ET.Element]:
    return {child: parent for parent in root.iter() for child in parent}


def flatten_glyph_uses(root: ET.Element) -> int:
    symbols = {
        element.get("id"): element
        for element in root.iter()
        if local_name(element.tag) == "symbol" and element.get("id")
    }

    parent_map = build_parent_map(root)
    replacements = 0

    for use in list(root.iter(svg_tag("use"))):
        href = use.get(f"{{{XLINK_NS}}}href") or use.get("href")
        if not href or not href.startswith("#glyph"):
            continue

        symbol = symbols.get(href[1:])
        parent = parent_map.get(use)
        if symbol is None or parent is None:
            continue

        group = ET.Element(svg_tag("g"))
        x = use.get("x")
        y = use.get("y")
        transform_parts = []
        if x or y:
            transform_parts.append(f"translate({x or '0'} {y or '0'})")
        if use.get("transform"):
            transform_parts.append(use.get("transform"))

        for key, value in use.attrib.items():
            if key in {"x", "y", "width", "height", "transform", "href", f"{{{XLINK_NS}}}href"}:
                continue
            group.set(key, value)
        if transform_parts:
            group.set("transform", " ".join(transform_parts))

        for child in list(symbol):
            group.append(copy.deepcopy(child))

        siblings = list(parent)
        insert_at = siblings.index(use)
        parent.remove(use)
        parent.insert(insert_at, group)
        replacements += 1

    return replacements


def prune_glyph_symbols(root: ET.Element) -> None:
    parent_map = build_parent_map(root)
    defs_to_prune = []

    for element in list(root.iter()):
        if local_name(element.tag) != "symbol":
            continue
        symbol_id = element.get("id", "")
        if not symbol_id.startswith("glyph"):
            continue
        parent = parent_map.get(element)
        if parent is not None:
            parent.remove(element)

    for element in list(root.iter()):
        if local_name(element.tag) == "defs" and len(list(element)) == 0:
            defs_to_prune.append(element)

    parent_map = build_parent_map(root)
    for defs in defs_to_prune:
        parent = parent_map.get(defs)
        if parent is not None:
            parent.remove(defs)


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: flatten_svg_uses.py <svg-path>", file=sys.stderr)
        return 2

    path = argv[1]
    tree = ET.parse(path)
    root = tree.getroot()

    replacements = flatten_glyph_uses(root)
    if replacements:
        prune_glyph_symbols(root)
        tree.write(path, encoding="utf-8", xml_declaration=True)

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
