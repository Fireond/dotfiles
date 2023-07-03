import subprocess


def git_update():
    repo_path = '.'
    try:
        # Run 'git add --all' command
        subprocess.run(['git', 'add', '--all'], cwd=repo_path, check=True)

        # Run 'git commit -m "update"' command
        subprocess.run(['git', 'commit', '-m', 'update'],
                       cwd=repo_path, check=True)

        print("Git update successful!")

    except subprocess.CalledProcessError as e:
        print(f"Git update failed: {e}")


# Call the function to perform the update
git_update()
