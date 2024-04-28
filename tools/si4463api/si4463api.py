"""Classes to understand the si4463 APIs."""
from __future__ import annotations
import re
import sys

RGX_COMMAND_SUMMARY = re.compile(r"^Command Summary\S*\n(?P<commands>.*)^Property Summary", re.MULTILINE | re.DOTALL)
RGX_PROPERTY_SUMMARY = re.compile(r"^Group\s+Number[^\n]*\n(?P<property>.*?)(?=^(?:Group\s+Number|Command Details))", re.MULTILINE | re.DOTALL)
RGX_COMMAND_DETAILS = re.compile(r"^Command Details\S*\n(?P<details>.*?)(?=^Property Details)", re.MULTILINE | re.DOTALL)
RGX_PROPERTY_DETAILS = re.compile(r"^Property Details\S*\n(?P<details>.*?)(?=^(?:Property Details|Copyright))", re.MULTILINE | re.DOTALL)


class Si4463Api:
    def read_command_summary(self: Si4463Api, commands: str):
        pass

    def read_property_summary(self: Si4463Api, property: str):
        pass

    def read_command_details(self: Si4463Api, details: str):
        pass

    def read_property_details(self: Si4463Api, details: str):
        pass

    def __init__(self: Si4463Api, filename: str):
        definition: str = None
        with open(filename, "r") as source:
            # It's a big file but memory is cheap and plentiful!
            definition = source.read()

        match = RGX_COMMAND_SUMMARY.search(definition)
        assert match, "Command Summary not found"
        self.read_command_summary(match.group("commands"))

        matches = RGX_PROPERTY_SUMMARY.findall(definition)
        assert matches, "Property Summaries not found."
        for match in matches:
            self.read_property_summary(match)

        match = RGX_COMMAND_DETAILS.search(definition)
        assert match, "Command Details not found."
        self.read_command_details(match.group("details"))

        match = RGX_PROPERTY_DETAILS.search(definition)
        assert match, "Property Details not found."
        self.read_property_details(match.group("details"))


Si4463Api(sys.argv[1])