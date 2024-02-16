dashboard "benchmarks_and_controls" {

  input "benchmark" {
    width = 4
    sql = <<EOQ
      select distinct 
        title || ' (' || group_id || ')' as label,
        group_id as value,
        jsonb_build_object(
          'group_id', group_id
        )
      from
        csv.benchmarks
    EOQ
  }

  graph {
    title = "Benchmark explorer: graph"

    node {
      args = [self.input.benchmark]
      category = category.benchmark
      sql = <<EOQ
        select distinct 
          group_id as id,
          group_id as title,
          jsonb_build_object(
            'title', title,
            'ok', ( select count(*) from csv.benchmarks where group_id = $1 and status = 'ok'),
            'alarm', ( select count(*) from csv.benchmarks where group_id = $1 and status = 'alarm')
          ) as properties
        from
          csv.benchmarks
        where group_id = $1
      EOQ
    }
    
    node {
      args = [self.input.benchmark]
      category = category.control
      sql = <<EOQ
        select 
          control_id as id,
          control_id as title,
          jsonb_build_object(
            'title', control_id,
            'ok', count(*) filter (where status = 'ok'),
            'alarm', count(*) filter (where status = 'alarm'),
            'info', count(*) filter (where status = 'info'),
            'error', count(*) filter (where status = 'error')
          ) as properties
        from
          csv.benchmarks
        where group_id = $1
        group by control_id
      EOQ
    }

    node {
      args = [self.input.benchmark]
      category = category.result
      sql = <<EOQ
        select 
          control_id || ':' || coalesce(resource, 'no_resource') as id,
          control_id || ' - ' || coalesce(resource, 'No Resource') as title,
          jsonb_build_object(
            'control_id', control_id,
            'resource', coalesce(resource, 'No Resource'),
            'status', status
          ) as properties
        from
          csv.benchmarks
        where group_id = $1 and (resource is not null or resource = '')
      EOQ
    }

    edge {
      args = [self.input.benchmark]
      sql = <<EOQ
        select
          group_id as from_id,
          control_id as to_id
        from
          csv.benchmarks
        where group_id = $1
      EOQ
    }

    edge {
      args = [self.input.benchmark]
      sql = <<EOQ
        select
          control_id as from_id,
          control_id || ':' || resource as to_id
        from
          csv.benchmarks
        where group_id = $1
      EOQ
    }

    edge {
      args = [self.input.benchmark]
      sql = <<EOQ
        select
          control_id as from_id,
          control_id || ':' || coalesce(resource, 'no_resource') as to_id
        from
          csv.benchmarks
        where group_id = $1 and (resource is not null or resource = '')
      EOQ
    }    


  }
}

