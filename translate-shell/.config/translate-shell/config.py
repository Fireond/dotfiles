"""Configure."""

from translate_shell.config import Configuration


def configure() -> Configuration:
    """Configure.

    :rtype: Configuration
    """
    config = Configuration()
    config.target_lang = "zh_CN"
    config.translators = "google,speaker"
    return config
