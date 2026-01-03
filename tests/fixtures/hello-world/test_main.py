from main import main


def test_main_output(capsys):
    """Test that main() prints Hello, World!"""
    main()
    captured = capsys.readouterr()
    assert captured.out == "Hello, World!\n"
