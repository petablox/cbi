class AppFinder(list):
    def __init__(self, client):
        import Keys
        self[0:0] = client.all_dirs(Keys.applications)
