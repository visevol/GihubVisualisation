require "benchmark"

namespace :repositories do
  desc <<~DESCRIPTION
    Benchmark the time it takes to sync a repository.

    Usage: REPOSITORY_ID=1 bin/rake repositories:benchmark_sync
  DESCRIPTION
  task benchmark_sync: :environment do
    repository_id = ENV["REPOSITORY_ID"]
    raise ArgumentError, <<~ERROR unless repository_id
      missing REPOSITORY_ID environment variable.

      Usage: REPOSITORY_ID=1 bin/rake repositories:benchmark_sync
    ERROR

    repository = Repository.find(repository_id)

    puts "deleting commits and file changes of repository: #{repository.remote_url}..."
    CommitFileChange
      .joins(commit: :repository)
      .where(commit: { repository_id: repository.id })
      .delete_all
    Commit.where(repository_id: repository.id).delete_all
    puts "done."

    puts "syncing #{repository.remote_url}..."
    time = Benchmark.measure do
      RepositorySyncService.new(repository).index
    end

    file_changes_count = CommitFileChange
      .joins(commit: :repository)
      .where(commit: { repository_id: repository.id })
      .count

    puts <<~RESULTS
      Sync duration: #{time.to_s.strip}
      Commit created: #{repository.commits.count}
      File changes created: #{file_changes_count}
    RESULTS
  end
end
